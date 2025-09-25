<?php

namespace App\Controller;

use App\Entity\Event;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class EventController extends AbstractController
{
    #[Route('/api/events', name: 'api_events', methods: ['GET'])]
    public function index(EntityManagerInterface $em): JsonResponse
    {
        $events = $em->getRepository(Event::class)->findBy(['isPublished' => true]);
        
        if (empty($events)) {
            return new JsonResponse(['message' => 'No events found']);
        }
        
        $data = [];
        foreach ($events as $event) {
            $data[] = [
                'id' => $event->getId(),
                'title' => $event->getTitle(),
                'description' => $event->getDescription(),
                'date' => $event->getDate()->format('Y-m-d H:i:s'),
                'location' => $event->getLocation(),
                'image' => $event->getImage(), // ← AJOUTÉ
                'price' => $event->getPrice(),
                'maxAttendees' => $event->getMaxAttendees(),
                'organizer' => $event->getCreatedBy()->getName()
            ];
        }
        
        return new JsonResponse($data);
    }

    #[Route('/api/events/{id}', name: 'api_event_show', methods: ['GET'])]
    public function show(int $id, EntityManagerInterface $em): JsonResponse
    {
        $event = $em->getRepository(Event::class)->find($id);
        
        if (!$event) {
            return new JsonResponse(['error' => 'Event not found'], 404);
        }

        return new JsonResponse([
            'id' => $event->getId(),
            'title' => $event->getTitle(),
            'description' => $event->getDescription(),
            'date' => $event->getDate()->format('Y-m-d H:i:s'),
            'location' => $event->getLocation(),
            'image' => $event->getImage(), // ← AJOUTÉ
            'price' => $event->getPrice(),
            'maxAttendees' => $event->getMaxAttendees(),
            'organizer' => $event->getCreatedBy()->getName(),
            'createdAt' => $event->getCreatedAt()->format('Y-m-d H:i:s')
        ]);
    }

    #[Route('/api/events', name: 'api_event_create', methods: ['POST'])]
    public function create(Request $request, EntityManagerInterface $em): JsonResponse
    {
        $user = $this->getUser();
        if (!$user) {
            return new JsonResponse(['error' => 'Authentication required'], 401);
        }
        
        if (!in_array('ROLE_ORGANIZER', $user->getRoles())) {
            return new JsonResponse(['error' => 'Only organizers can create events'], 403);
        }

        $data = json_decode($request->getContent(), true);

        if (empty($data['title']) || empty($data['description'])) {
            return new JsonResponse(['error' => 'Title and description are required'], 400);
        }

        $event = new Event();
        $event->setTitle($data['title']);
        $event->setDescription($data['description']);
        $event->setDate(new \DateTime($data['date'] ?? 'now'));
        $event->setLocation($data['location'] ?? 'Unknown location');
        $event->setPrice($data['price'] ?? 0);
        $event->setMaxAttendees($data['maxAttendees'] ?? 50);
        $event->setIsPublished(true);
        $event->setCreatedAt(new \DateTime());
        $event->setUpdateAt(new \DateTime());
        $event->setCreatedBy($user);

        // GESTION DE L'IMAGE ← AJOUTÉ
        if (isset($data['image']) && !empty($data['image'])) {
            $event->setImage($data['image']);
        } else {
            // Image par défaut si aucune fournie
            $event->setImage('/images/default-event.jpg');
        }

        $em->persist($event);
        $em->flush();

        return new JsonResponse([
            'message' => 'Event created successfully!',
            'event' => [
                'id' => $event->getId(),
                'title' => $event->getTitle(),
                'image' => $event->getImage() // ← AJOUTÉ
            ]
        ], 201);
    }

    #[Route('/api/events/{id}', name: 'api_event_update', methods: ['PUT'])]
    public function update(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        $user = $this->getUser();
        if (!$user) {
            return new JsonResponse(['error' => 'Authentication required'], 401);
        }
        
        if (!in_array('ROLE_ORGANIZER', $user->getRoles())) {
            return new JsonResponse(['error' => 'Only organizers can update events'], 403);
        }

        $event = $em->getRepository(Event::class)->find($id);
        if (!$event) {
            return new JsonResponse(['error' => 'Event not found'], 404);
        }

        if ($event->getCreatedBy()->getId() !== $user->getId()) {
            return new JsonResponse(['error' => 'You can only update your own events'], 403);
        }

        $data = json_decode($request->getContent(), true);

        if (isset($data['title'])) $event->setTitle($data['title']);
        if (isset($data['description'])) $event->setDescription($data['description']);
        if (isset($data['date'])) $event->setDate(new \DateTime($data['date']));
        if (isset($data['location'])) $event->setLocation($data['location']);
        if (isset($data['price'])) $event->setPrice($data['price']);
        if (isset($data['maxAttendees'])) $event->setMaxAttendees($data['maxAttendees']);
        
        // GESTION DE L'IMAGE ← AJOUTÉ
        if (isset($data['image'])) {
            $event->setImage($data['image']);
        }

        $event->setUpdateAt(new \DateTime());
        $em->flush();

        return new JsonResponse([
            'message' => 'Event updated successfully',
            'event' => [
                'id' => $event->getId(),
                'title' => $event->getTitle(),
                'description' => $event->getDescription(),
                'date' => $event->getDate()->format('Y-m-d H:i:s'),
                'location' => $event->getLocation(),
                'image' => $event->getImage(), // ← AJOUTÉ
                'price' => $event->getPrice(),
                'maxAttendees' => $event->getMaxAttendees(),
            ]
        ]);
    }

    #[Route('/api/events/{id}', name: 'api_event_delete', methods: ['DELETE'])]
    public function delete(int $id, EntityManagerInterface $em): JsonResponse
    {
        $user = $this->getUser();
        if (!$user) {
            return new JsonResponse(['error' => 'Authentication required'], 401);
        }
        
        if (!in_array('ROLE_ORGANIZER', $user->getRoles())) {
            return new JsonResponse(['error' => 'Only organizers can delete events'], 403);
        }

        $event = $em->getRepository(Event::class)->find($id);
        if (!$event) {
            return new JsonResponse(['error' => 'Event not found'], 404);
        }

        if ($event->getCreatedBy()->getId() !== $user->getId()) {
            return new JsonResponse(['error' => 'You can only delete your own events'], 403);
        }

        $em->remove($event);
        $em->flush();

        return new JsonResponse(['message' => 'Event deleted successfully']);
    }
}