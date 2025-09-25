<?php

namespace App\Controller;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;

class AuthController extends AbstractController
{
    #[Route('/api/register', name: 'api_register', methods: ['POST'])]
    public function register(Request $request, EntityManagerInterface $em, UserPasswordHasherInterface $passwordHasher): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);

            if (!isset($data['email'], $data['password'], $data['name'], $data['type'])) {
                return new JsonResponse(['error' => 'Missing fields: email, password, name, type'], 400);
            }

            $existingUser = $em->getRepository(User::class)->findOneBy(['email' => $data['email']]);
            if ($existingUser) {
                return new JsonResponse(['error' => 'Email already registered'], 400);
            }

            $user = new User();
            $user->setEmail($data['email']);
            $user->setName($data['name']);
            $user->setType($data['type']);
            $user->setCreatedAt(new \DateTime());
            
            // Définir les rôles selon le type
            if ($data['type'] === 'organizer') {
                $user->setRoles(['ROLE_ORGANIZER', 'ROLE_USER']);
            } else {
                $user->setRoles(['ROLE_USER']);
            }

            $hashedPassword = $passwordHasher->hashPassword($user, $data['password']);
            $user->setPassword($hashedPassword);

            $em->persist($user);
            $em->flush();

            return new JsonResponse([
                'message' => 'User registered successfully',
                'user' => [
                    'id' => $user->getId(),
                    'email' => $user->getEmail(),
                    'name' => $user->getName(),
                    'type' => $user->getType(),
                    'roles' => $user->getRoles()
                ]
            ], 201);

        } catch (\Exception $e) {
            return new JsonResponse(['error' => $e->getMessage()], 500);
        }
    }

    #[Route('/api/login', name: 'api_login', methods: ['POST'])]
    public function login(JWTTokenManagerInterface $jwtManager): JsonResponse
    {
        $user = $this->getUser();
        
        if (!$user) {
            return new JsonResponse(['error' => 'Invalid credentials'], 401);
        }

        $token = $jwtManager->create($user);

        return new JsonResponse([
            'token' => $token,
            'user' => [
                'id' => $user->getId(),
                'email' => $user->getEmail(),
                'name' => $user->getName(),
                'type' => $user->getType(),
                'roles' => $user->getRoles()
            ]
        ]);
    }

    #[Route('/api/me', name: 'api_me', methods: ['GET'])]
    public function me(): JsonResponse
    {
        $user = $this->getUser();
        
        if (!$user) {
            return new JsonResponse(['error' => 'Not authenticated'], 401);
        }

        return new JsonResponse([
            'id' => $user->getId(),
            'email' => $user->getEmail(),
            'name' => $user->getName(),
            'type' => $user->getType(),
            'roles' => $user->getRoles()
        ]);
    }
}